class Sjq < Formula
  desc "jq, but for AI streaming: read LLM streams at a glance"
  homepage "https://github.com/vivgrid/sjq"
  version "1.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vivgrid/sjq/releases/download/v1.1.1/sjq-aarch64-apple-darwin.tar.gz"
      sha256 "efdc6514829b44de8582af633905bf428d724824f4af29e63927f7edf7f2ed47"
    end
    on_intel do
      url "https://github.com/vivgrid/sjq/releases/download/v1.1.1/sjq-x86_64-apple-darwin.tar.gz"
      sha256 "c4b76ad8e668fcbad423228f0b5426b7e4f1fae7f22a5d46faf30b560a1e6410"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vivgrid/sjq/releases/download/v1.1.1/sjq-aarch64-unknown-linux-musl.tar.gz"
      sha256 "59f56cae339cabbd5a04414c6afd27fb31c9c10f010c420c5b5b07a6d94a56c8"
    end
    on_intel do
      url "https://github.com/vivgrid/sjq/releases/download/v1.1.1/sjq-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0714ae26c111f93e1f8e43376f23b6641b51f4fd78827e4792a3e5b8d6e9f1b5"
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
