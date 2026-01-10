module Api
  module V1
    # SessionsController handles authentication using JWT tokens
    # Provides login, logout, and token refresh endpoints
    class SessionsController < BaseController
      include JwtConfig

      # POST /api/v1/login
      # Authenticates a seller and returns JWT tokens
      def create
        seller = Seller.find_by(email: params[:email]&.downcase)

        unless seller&.authenticate(params[:password])
          return render_error("Email o contraseña incorrectos", status: :unauthorized)
        end

        # Generate access and refresh tokens
        access_token = Auth::TokenService.generate_access_token(seller)
        refresh_token = Auth::TokenService.generate_refresh_token(seller)

        # Store refresh token in database for revocation tracking
        refresh_payload = Auth::TokenService.decode(refresh_token)
        RefreshToken.create_from_token(seller, refresh_token, refresh_payload)

        # Return tokens and seller data
        render_success({
          access_token: access_token,
          refresh_token: refresh_token,
          token_type: 'Bearer',
          expires_in: JWT_ACCESS_TOKEN_EXPIRATION.to_i,
          seller: SellerSerializer.new(seller).serializable_hash[:data]
        })
      rescue StandardError => e
        Rails.logger.error("Login error: #{e.message}")
        render_error("Error al iniciar sesión", status: :internal_server_error)
      end

      # POST /api/v1/refresh
      # Issues a new access token using a valid refresh token
      def refresh
        refresh_token = extract_token_from_header

        unless refresh_token
          return render_error("Refresh token requerido", status: :unauthorized)
        end

        # Decode and verify refresh token
        payload = Auth::TokenService.decode(refresh_token)

        unless Auth::TokenService.refresh_token?(payload)
          return render_error("Token inválido", status: :unauthorized)
        end

        # Verify token exists in database and is not revoked
        stored_token = RefreshToken.find_by_jti(payload[:jti])

        unless stored_token&.valid_token?
          return render_error("Refresh token inválido o revocado", status: :unauthorized)
        end

        # Generate new access token
        seller = Seller.find(payload[:seller_id])
        access_token = Auth::TokenService.generate_access_token(seller)

        render_success({
          access_token: access_token,
          token_type: 'Bearer',
          expires_in: JWT_ACCESS_TOKEN_EXPIRATION.to_i
        })
      rescue Auth::TokenService::ExpiredTokenError
        render_error("Refresh token expirado", status: :unauthorized)
      rescue Auth::TokenService::InvalidTokenError
        render_error("Refresh token inválido", status: :unauthorized)
      rescue ActiveRecord::RecordNotFound
        render_error("Usuario no encontrado", status: :unauthorized)
      rescue StandardError => e
        Rails.logger.error("Token refresh error: #{e.message}")
        render_error("Error al refrescar token", status: :internal_server_error)
      end

      # DELETE /api/v1/logout
      # Revokes the current refresh token
      def destroy
        refresh_token = extract_token_from_header

        if refresh_token
          payload = Auth::TokenService.verify_token(refresh_token)

          if payload && Auth::TokenService.refresh_token?(payload)
            stored_token = RefreshToken.find_by_jti(payload[:jti])
            stored_token&.revoke!
          end
        end

        render json: { message: "Sesión cerrada exitosamente" }, status: :ok
      rescue StandardError => e
        Rails.logger.error("Logout error: #{e.message}")
        render json: { message: "Sesión cerrada" }, status: :ok
      end

      private

      # Extract Bearer token from Authorization header
      #
      # @return [String, nil] The token if present
      def extract_token_from_header
        header = request.headers['Authorization']
        return nil unless header

        # Extract token from "Bearer <token>" format
        header.split(' ').last if header.start_with?('Bearer ')
      end
    end
  end
end
