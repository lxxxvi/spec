require_relative '../../spec_helper'

ruby_version_is "2.7" do
  describe "Fiber#raise" do
    it "raises on unborn fiber" do
      -> {
        f = Fiber.new {}
        f.raise
      }.should raise_error(FiberError, /cannot raise exception on unborn fiber/)
    end

    it "raises on dead fiber" do
      -> {
        f = Fiber.new { :first }
        f.resume
        f.raise
      }.should raise_error(FiberError, /dead fiber called/)
    end

    it "raises with default error" do
      -> {
        f = Fiber.new { :first; Fiber.yield; :second }
        f.resume
        f.raise
      }.should raise_error(RuntimeError)
    end

    it "raises with string" do
      -> {
        f = Fiber.new { :first; Fiber.yield; :second }
        f.resume
        f.raise "This is intended"
      }.should raise_error(RuntimeError, /This is intended/)
    end

    it "raises custom exception" do
      -> {
        f = Fiber.new { :first; Fiber.yield; :second }
        f.resume
        f.raise ArgumentError
      }.should raise_error(ArgumentError)
    end

    it "raises custom exception and message" do
      -> {
        f = Fiber.new { :first; Fiber.yield; :second }
        f.resume
        f.raise ArgumentError, "No argument provided"
      }.should raise_error(ArgumentError, /No argument provided/)
    end

    it "raises custom exception, message and backtrace" do
      -> {
        f = Fiber.new { :first; Fiber.yield; :second }
        f.resume
        f.raise ArgumentError, "No argument provided", ["foo", "bar"]
      }.should raise_error do |error|
        error.backtrace.should == ["foo", "bar"]
      end
    end
  end
end
