require 'spec_helper'

describe SemanticVersioning::Version do

  let(:valid_version_str)       { '1.2.3' }
  let(:valid_ver_pre_str)       { '1.2.3-alpha.1' }
  let(:valid_ver_build_str)     { '1.2.3+20130313144700' }
  let(:valid_ver_pre_build_str) { '1.2.3-beta+exp.sha.54f85' }

  let(:valid_version) do
    SemanticVersioning::Version.new '1.2.3'
  end
  let(:valid_ver_pre) do
    SemanticVersioning::Version.new '1.2.3-alpha.1'
  end
  let(:valid_ver_build) do
    SemanticVersioning::Version.new '1.2.3+20130313144700'
  end
  let(:valid_ver_pre_build) do
    SemanticVersioning::Version.new '1.2.3-beta+exp.sha.54f85'
  end

  describe '#initialize' do

    describe "Check argument's validation" do

      [
        '1.2.3',
        '0.0.1',
        '12.34.56',
        '1.2.3-alpha',
        '1.2.3-alpha.1',
        '1.2.3-0.3.7',
        '1.2.3-x.7.z.92',
        '1.2.3-alpha+001',
        '1.2.3+20130313144700',
        '1.2.3-beta+exp.sha.5114f85'
      ].each do |v|
        it "#{v} is a valid Semantic Versioning string." do
          expect do
            SemanticVersioning::Version.new v
          end.to_not raise_error
        end
      end

      [
        'a.b.c',
        '1.2.a',
        '1.b.3',
        'c.2.3',
        '0.0.01',
        '0.02.1',
        '03.2.1',
        '1.2.3-',
        '1.2.3-+',
        '1.2.3-0.3.7+',
        '1.2.3-x.#.z.92',
        '1.2.3-alpha+00%',
        '1.2.3+@20130313144700'
      ].each do |v|
        it "#{v} is not a valid Semantic Versioning string." do
          expect do
            SemanticVersioning::Version.new v
          end.to raise_error(ArgumentError)
        end
      end

      [
        :major,
        :minor,
        :patch
      ].each do |l|
        it ":#{l} is a valid incremental_label string." do
          expect do
            SemanticVersioning::Version.new valid_version_str, l
          end.to_not raise_error
        end

        it "#{l} is setting incremental_label." do
          actual = SemanticVersioning::Version.new valid_version_str, l
          expect(actual.incremental_label).to eq(l)
        end
      end

      [
        :abc,
        'patch',
        123
      ].each do |l|
        it ":#{l} is not a valid incremental_label string." do
          expect do
            SemanticVersioning::Version.new valid_version_str, l
          end.to raise_error(ArgumentError)
        end
      end
    end

    describe "Setting version '1.2.3'" do

      it 'major: 1, minor: 2, patch: 3.' do
        expect(valid_version.major).to eq 1
        expect(valid_version.minor).to eq 2
        expect(valid_version.patch).to eq 3
        expect(valid_version.pre).to eq nil
        expect(valid_version.build).to eq nil
      end
    end

    describe "Setting version '1.2.3-alpha.1'" do

      it "major: 1, minor: 2, patch: 3, pre: 'alpha.1'." do
        expect(valid_ver_pre.major).to eq 1
        expect(valid_ver_pre.minor).to eq 2
        expect(valid_ver_pre.patch).to eq 3
        expect(valid_ver_pre.pre).to eq 'alpha.1'
        expect(valid_ver_pre.build).to eq nil
      end
    end

    describe "Setting version '1.2.3+20130313144700'" do

      it "major: 1, minor: 2, patch: 3, build: '20130313144700'." do
        expect(valid_ver_build.major).to eq 1
        expect(valid_ver_build.minor).to eq 2
        expect(valid_ver_build.patch).to eq 3
        expect(valid_ver_build.pre).to eq nil
        expect(valid_ver_build.build).to eq '20130313144700'
      end
    end

    describe "Setting version '1.2.3-beta+exp.sha.54f85'" do

      it "major: 1, minor: 2, patch: 3, pre: 'beta', build: 'exp.sha.54f85'." do
        expect(valid_ver_pre_build.major).to eq 1
        expect(valid_ver_pre_build.minor).to eq 2
        expect(valid_ver_pre_build.patch).to eq 3
        expect(valid_ver_pre_build.pre).to eq 'beta'
        expect(valid_ver_pre_build.build).to eq 'exp.sha.54f85'
      end
    end
  end

  describe '#to_a' do

    context ' 1.2.3' do
      subject { valid_version.to_a }
      it { is_expected.to eq [1, 2, 3, nil, nil] }
    end

    context ' 1.2.3-alpha.1' do
      subject { valid_ver_pre.to_a }
      it { is_expected.to eq [1, 2, 3, 'alpha.1', nil] }
    end

    context ' 1.2.3+20130313144700' do
      subject { valid_ver_build.to_a }
      it { is_expected.to eq [1, 2, 3, nil, '20130313144700'] }
    end

    context ' 1.2.3-beta+exp.sha.54f85' do
      subject { valid_ver_pre_build.to_a }
      it { is_expected.to eq [1, 2, 3, 'beta', 'exp.sha.54f85'] }
    end
  end

  describe '#to_s' do

    context ' 1.2.3' do
      subject { valid_version.to_s }
      it { is_expected.to eq '1.2.3' }
    end

    context ' 1.2.3-alpha.1' do
      subject { valid_ver_pre.to_s }
      it { is_expected.to eq '1.2.3-alpha.1' }
    end

    context ' 1.2.3+20130313144700' do
      subject { valid_ver_build.to_s }
      it { is_expected.to eq '1.2.3+20130313144700' }
    end

    context ' 1.2.3-beta+exp.sha.54f85' do
      subject { valid_ver_pre_build.to_s }
      it { is_expected.to eq '1.2.3-beta+exp.sha.54f85' }
    end
  end

  describe '#to_hash' do
    context ' 1.2.3' do
      subject { valid_version.to_hash }
      it do
        is_expected.to eq(
          major: 1,
          minor: 2,
          patch: 3,
          pre: nil,
          build: nil
        )
      end
    end

    context ' 1.2.3-alpha.1' do
      subject { valid_ver_pre.to_hash }
      it do
        is_expected.to eq(
          major: 1,
          minor: 2,
          patch: 3,
          pre: 'alpha.1',
          build: nil
        )
      end
    end

    context ' 1.2.3+20130313144700' do
      subject { valid_ver_build.to_hash }
      it do
        is_expected.to eq(
          major: 1,
          minor: 2,
          patch: 3,
          pre: nil,
          build: '20130313144700'
        )
      end
    end

    context ' 1.2.3-beta+exp.sha.54f85' do
      subject { valid_ver_pre_build.to_hash }
      it do
        is_expected.to eq(
          major: 1,
          minor: 2,
          patch: 3,
          pre: 'beta',
          build: 'exp.sha.54f85'
        )
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

  describe '#<=>' do

    it 'String Object is a invalid parameter.' do
      expect(valid_version <=> '1.2.3').to eq nil
    end

    it "Comparing '1.2.3' and '1.2.3' is returned 0." do
      actual = SemanticVersioning::Version.new '1.2.3'
      expect(actual <=> valid_version).to eq 0
    end

    it 'When Comparing, build parameter is ignored.' do
      actual = SemanticVersioning::Version.new '1.2.3+build20010101001'
      expect(actual <=> valid_version).to eq 0
    end

    [
      '1.2.4',
      '1.3.3',
      '2.2.3',
      '1.2.4-alpha.0',
      '1.2.4-alpha.0+build20010101001'
    ].each do |v|
      it "Comparing '#{v}' and '1.2.3' is returned a regular value." do
        actual = SemanticVersioning::Version.new v
        expect(actual <=> valid_version).to be > 0
      end
    end

    [
      '1.2.2',
      '1.1.9',
      '0.9.9',
      '1.2.3-alpha.0',
      '1.2.3-alpha.0+build20010101001'
    ].each do |v|
      it "Comparing '#{v}' and '1.2.3' is returned a negative value." do
        actual = SemanticVersioning::Version.new v
        expect(actual <=> valid_version).to be < 0
      end
    end
  end
end
