class Result
  attr_reader :value, :errors

  def initialize(success:, value: nil, errors: [])
    @success = success
    @value = value
    @errors = Array(errors)
  end

  def self.success(value = nil)
    new(success: true, value: value)
  end

  def self.failure(errors)
    new(success: false, errors: errors)
  end

  def success?
    @success
  end

  def failure?
    !@success
  end

  def on_success
    yield(value) if success? && block_given?
    self
  end

  def on_failure
    yield(errors) if failure? && block_given?
    self
  end
end