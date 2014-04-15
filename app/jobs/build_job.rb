class BuildJob < Struct.new(:build_runner)
  include Monitorable

  def perform
    build_runner.run
  end

  def error(job, exception)
    super
    if exception.is_a? Octokit::NotFound
      update_failed_at(job)
    end
  end

  private

  def update_failed_at(job, time=Time.now.utc)
    job.update_attribute(failed_at: time)
  end
end
