require 'spec_helper'

describe SemanticVersioning::Version do

  describe '#initialize' do

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

      it 'major is 1, minor is 2, patch is 3.' do
        expect(valid_version.major).to eq 1
        expect(valid_version.minor).to eq 2
        expect(valid_version.patch).to eq 3
      end
    end
  end

  describe '#up' do

    let(:valid_version) { SemanticVersioning::Version.new '4.5.6' }

    context 'Default(:patch), Upgrade from version \'4.5.6\'' do

      it 'major is 4, minor is 5, patch is 7.' do
        expect(valid_version.up.major).to eq 4
        expect(valid_version.up.minor).to eq 5
        expect(valid_version.up.patch).to eq 7
      end
    end

    context 'incremental_label=:minor, Upgrade from version \'4.5.6\'' do

      it 'major is 4, minor is 6, patch is 0.' do
        valid_version.incremental_label = :minor
        expect(valid_version.up.major).to eq 4
        expect(valid_version.up.minor).to eq 6
        expect(valid_version.up.patch).to eq 0
      end
    end

    context 'incremental_label=:major, Upgrade from version \'4.5.6\'' do

      it 'major is 5, minor is 0, patch is 0.' do
        valid_version.incremental_label = :major
        expect(valid_version.up.major).to eq 5
        expect(valid_version.up.minor).to eq 0
        expect(valid_version.up.patch).to eq 0
      end
    end
  end

  describe '#up!' do

    let(:valid_version) { SemanticVersioning::Version.new '7.8.9' }

    context 'Default(:patch), Upgrade from version \'7.8.9\'' do

      it 'major is 7, minor is 8, patch is 10.' do
        valid_version.up!
        expect(valid_version.major).to eq 7
        expect(valid_version.minor).to eq 8
        expect(valid_version.patch).to eq 10
      end
    end

    context 'incremental_label=:minor, Upgrade from version \'7.8.9\'' do

      it 'major is 7, minor is 9, patch is 0.' do
        valid_version.incremental_label = :minor
        valid_version.up!
        expect(valid_version.major).to eq 7
        expect(valid_version.minor).to eq 9
        expect(valid_version.patch).to eq 0
      end
    end

    context 'incremental_label=:major, Upgrade from version \'7.8.9\'' do

      it 'major is 8, minor is 0, patch is 0.' do
        valid_version.incremental_label = :major
        valid_version.up!
        expect(valid_version.major).to eq 8
        expect(valid_version.minor).to eq 0
        expect(valid_version.patch).to eq 0
      end
    end
  end
end
