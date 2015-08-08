require_relative '../spec_helper'

module Gocd
  RSpec.describe Server do
    subject { Gocd::Server.new }

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
    end
  end
end
