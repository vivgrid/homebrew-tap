class Sjq < Formula
  desc "jq, but for AI streaming: read LLM streams at a glance"
  homepage "https://github.com/vivgrid/sjq"
  url "https://github.com/vivgrid/sjq/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d936da9bfd980bfd63d54d67c275b3e408f3aeb17d0ccf667fed89e13b7b901e"
  license "MIT"
  head "https://github.com/vivgrid/sjq.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"stream.txt").write <<~EOS
      data: {"id":"chatcmpl-test","object":"chat.completion.chunk","created":1792040102,"model":"test-model","choices":[{"index":0,"delta":{"role":"assistant","content":null},"finish_reason":null}]}

      data: {"id":"chatcmpl-test","object":"chat.completion.chunk","created":1792040102,"model":"test-model","choices":[{"index":0,"delta":{"content":"Hello"},"finish_reason":null}]}

      data: {"id":"chatcmpl-test","object":"chat.completion.chunk","created":1792040102,"model":"test-model","choices":[{"index":0,"delta":{},"finish_reason":null},"finish_reason":"stop"}]}

      data: [DONE]
    EOS
    assert_match "Hello", shell_output("#{bin}/sjq #{testpath}/stream.txt")
  end
end
