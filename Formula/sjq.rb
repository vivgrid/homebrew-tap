class Sjq < Formula
  desc "jq, but for AI streaming: read LLM streams at a glance"
  homepage "https://github.com/vivgrid/sjq"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vivgrid/sjq/releases/download/v1.0.0/sjq-aarch64-apple-darwin.tar.gz"
      sha256 "088d5eecf516c0886ea9c584e26333c0f8b7665afa878c1ebe12fb478721b48d"
    end
    on_intel do
      url "https://github.com/vivgrid/sjq/releases/download/v1.0.0/sjq-x86_64-apple-darwin.tar.gz"
      sha256 "ea378aaf3636e83e22477314a0e6f9c73b44270e5c3406e97b5ceb54605f825f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vivgrid/sjq/releases/download/v1.0.0/sjq-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2b007bc460f8ac5bea3ffda15255ce0bd7e5985f4258a76214dff581970f6471"
    end
    on_intel do
      url "https://github.com/vivgrid/sjq/releases/download/v1.0.0/sjq-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f6a06ea63f51177f082e3ebb1539949534702d96c72d80d20c14f820178ab7f1"
    end
  end

  def install
    bin.install "sjq"
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
