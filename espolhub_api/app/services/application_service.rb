class ApplicationService
  def self.call(...)
    new(...).call
  end

  def initialize
    @errors = []
  end

  def call
    raise NotImplementedError, "#{self.class} must implement #call"
  end

  def success?
    @errors.empty?
  end

  def errors
    @errors
  end

  private

  def add_error(message)
    @errors << message
  end

  def add_errors(messages)
    @errors.concat(Array(messages))
  end
end