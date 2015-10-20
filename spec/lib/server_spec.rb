require_relative '../spec_helper'

module Gocd
  RSpec.describe Server do
    let(:server_url_and_credentials) { %w(localhost 8153) }
    subject { Gocd::Server.new(server_url_and_credentials) }

    describe '#execute' do
      context 'no params passed' do
        it 'should return an error message' do
          expect(subject.execute([])).to eq I18n.t('server.errors.no_command')
        end
      end

      context 'unknown command passed' do
        it 'should return an error message' do
          expect(subject.execute(['asdf'])).to eq I18n.t('server.errors.unknown_command')
        end
      end

      describe '#verify_connection' do
        context 'correct host and ports' do
          context 'without authentication' do
            it 'get response 200 ok' do
              VCR.use_cassette('server_without_authentication') do
                expect(subject.verify_connection).to eq 'Connected successfully to localhost.'
              end
            end
          end

          context 'with authentication' do

            context 'correct credentials' do
              let(:server_url_and_credentials) { %w(localhost 8153 admin badger) }

              it 'get response 200 ok' do
                VCR.use_cassette('server_with_correct_credentials') do
                  expect(subject.verify_connection).to eq 'Connected successfully to localhost.'
                end
              end
            end

            context 'wrong credentials' do
              let(:server_url_and_credentials) { %w(localhost 8153 wrong_username badger) }

              it 'get response 200 ok' do
                VCR.use_cassette('server_with_wrong_credentials') do
                  expect(subject.verify_connection['error']).to eq('Bad credentials: Ensure username and password set and correct?')
                end
              end
            end
          end
        end

        context 'Invalid host or ports' do
          let(:server_url_and_credentials) { %w(somerandom_url invalid_port) }
            it 'get response 404 not_found' do
              VCR.use_cassette('server_invalid_url') do
                expect(subject.verify_connection).to eq 'Server not found at http://somerandom_url:invalid_port.'
              end
          end
        end

      end
    end
  end
end
