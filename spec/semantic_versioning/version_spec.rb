require 'spec_helper'

describe SemanticVersioning::Version do

  context '#initialize' do

    context 'Check argument validation' do

      [
        '1.2.3',
        '0.0.1',
        '12.34.56'
      ].each do |v|
        it "#{v} is valid Semantic Versioning string." do
          expect do
            SemanticVersioning::Version.new v
          end.to_not raise_error
        end
      end

      [
        'a.b.c',
        '1.2.a',
        '1.b.3',
        'c.2.3'
      ].each do |v|
        it "#{v} is invalid Semantic Versioning string." do
          expect do
            SemanticVersioning::Version.new v
          end.to raise_error(ArgumentError)
        end
      end
    end

    let(:valid_version) { SemanticVersioning::Version.new '1.2.3' }

    context 'Translate from version \'1.2.3\'' do

      it 'major is 1' do
        expect(valid_version.major).to eq 1
      end

      it 'minor is 2' do
        expect(valid_version.minor).to eq 2
      end

      it 'patch is 3' do
        expect(valid_version.patch).to eq 3
      end
    end
  end
end
