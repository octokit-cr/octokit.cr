require "jwt"
require "openssl"

# A helper module for encoding JWTs
# :param client_id [String] the client ID of the GitHub App
# :param private_key_path [String] the path to the private key file for the GitHub App
# :return [String] the encoded JWT   
module JWTHelper
  def self.encode(client_id : String, private_key_path : String) : String

    private_pem = File.read(private_key_path)
    private_key = OpenSSL::PKey::RSA.new(private_pem).to_pem

    payload = {
      "iss" => client_id,
      "exp" => Time.utc.to_unix + (10 * 60), # 10 minutes from now
      "iat" => Time.utc.to_unix - 60 # to account for clock drift
    }

    JWT.encode(payload, private_key, JWT::Algorithm::RS256)
  end
end
