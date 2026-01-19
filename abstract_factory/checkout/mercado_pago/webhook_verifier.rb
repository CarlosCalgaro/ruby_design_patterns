require_relative '../webhook_verifier'
module MercadoPago
  class WebhookVerifier
    def verify(signature:, payload:)
      puts ("Verifying webhook with signature #{signature} via Mercado Pago")
    end
  end
end