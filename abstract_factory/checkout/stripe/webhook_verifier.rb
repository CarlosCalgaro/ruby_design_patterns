require_relative '../webhook_verifier'
module Stripe
  class WebHookVerifier
    def verify(signature:, payload:)
      puts ("Verifying webhook with signature #{signature} via Stripe")
    end
  end
end