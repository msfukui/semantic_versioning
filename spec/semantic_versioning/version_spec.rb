require 'spec_helper'

describe SemanticVersioning::Version do
  describe '#initialize' do

    context 'A normal version number MUST take the form X.Y.Z \
    where X, Y, and Z are non-negative integers, \
    and MUST NOT contain leading zeroes. \
    A pre-release version MAY be denoted by appending a hyphen \
    and a series of dot separated identifiers immediately \
    following the patch version. Identifiers MUST comprise only \
    ASCII alphanumerics and hyphen [0-9A-Za-z-]. Identifiers MUST \
    NOT be empty. Numeric identifiers MUST NOT include leading zeroes. \
    Build metadata MAY be denoted by appending a plus sign \
    and a series of dot separated identifiers immediately following \
    the patch or pre-release version. Identifiers MUST comprise only \
    ASCII alphanumerics and hyphen [0-9A-Za-z-]. Identifiers MUST \
    NOT be empty.' do
      [
        ['1.9.0',                      1,  9, 0, nil,        nil],
        ['1.10.0',                     1, 10, 0, nil,        nil],
        ['1.11.0',                     1, 11, 0, nil,        nil],
        ['1.0.0-alpha',                1,  0, 0, 'alpha',    nil],
        ['1.0.0-alpha.1',              1,  0, 0, 'alpha.1',  nil],
        ['1.0.0-0.3.7',                1,  0, 0, '0.3.7',    nil],
        ['1.0.0-x.7.z.92',             1,  0, 0, 'x.7.z.92', nil],
        ['1.0.0-alpha+001',            1,  0, 0, 'alpha',    '001'],
        ['1.0.0+20130313144700',       1,  0, 0, nil,        '20130313144700'],
        ['1.0.0-beta+exp.sha.5114f85', 1,  0, 0, 'beta',     'exp.sha.5114f85']
      ].each do |(v, ma, mi, pa, pr, bu)|

        it "#{v} is a valid Semantic Versioning string." do
          expect do
            SemanticVersioning::Version.new v
          end.to_not raise_error
        end

        it "#{v}'s Major version is #{ma}." do
          actual = SemanticVersioning::Version.new v
          expected = ma
          expect(actual.major).to eq expected
        end

        it "#{v}'s Minor version is #{mi}." do
          actual = SemanticVersioning::Version.new v
          expected = mi
          expect(actual.minor).to eq expected
        end

        it "#{v}'s Patch version is #{pa}." do
          actual = SemanticVersioning::Version.new v
          expected = pa
          expect(actual.patch).to eq expected
        end

        it "#{v}'s pre-release version is #{pr}." do
          actual = SemanticVersioning::Version.new v
          expected = pr
          expect(actual.pre).to eq expected
        end

        it "#{v}'s Build metadata is #{bu}." do
          actual = SemanticVersioning::Version.new v
          expected = bu
          expect(actual.build).to eq expected
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
        '1.2.3-@alpha',
        '1.2.3-',
        '1.2.3-01.2',
        '1.2.3-1.02',
        '1.2.3+build&123',
        '1.2.3+',
        '1.2.3-beta+build#123',
        '1.2.3-beta+'
      ].each do |v|
        it "#{v} is not a valid Semantic Versioning string." do
          expect do
            SemanticVersioning::Version.new v
          end.to raise_error(ArgumentError)
        end
      end
    end

    context 'X is the major version, Y is the minor version, \
    and Z is the patch version.' do
      let(:valid_version_str) { '1.2.3' }

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
  end

  let(:valid_version) do
    SemanticVersioning::Version.new '1.2.3'
  end
  let(:valid_version_pre) do
    SemanticVersioning::Version.new '1.2.3-alpha.1'
  end
  let(:valid_version_build) do
    SemanticVersioning::Version.new '1.2.3+20130313144700'
  end
  let(:valid_version_pre_build) do
    SemanticVersioning::Version.new '1.2.3-beta+exp.sha.54f85'
  end

  describe '#to_a' do

    context ' 1.2.3' do
      subject { valid_version.to_a }
      it { is_expected.to eq [1, 2, 3, nil, nil] }
    end

    context ' 1.2.3-alpha.1' do
      subject { valid_version_pre.to_a }
      it { is_expected.to eq [1, 2, 3, 'alpha.1', nil] }
    end

    context ' 1.2.3+20130313144700' do
      subject { valid_version_build.to_a }
      it { is_expected.to eq [1, 2, 3, nil, '20130313144700'] }
    end

    context ' 1.2.3-beta+exp.sha.54f85' do
      subject { valid_version_pre_build.to_a }
      it { is_expected.to eq [1, 2, 3, 'beta', 'exp.sha.54f85'] }
    end
  end

  describe '#to_s' do

    context ' 1.2.3' do
      subject { valid_version.to_s }
      it { is_expected.to eq '1.2.3' }
    end

    context ' 1.2.3-alpha.1' do
      subject { valid_version_pre.to_s }
      it { is_expected.to eq '1.2.3-alpha.1' }
    end

    context ' 1.2.3+20130313144700' do
      subject { valid_version_build.to_s }
      it { is_expected.to eq '1.2.3+20130313144700' }
    end

    context ' 1.2.3-beta+exp.sha.54f85' do
      subject { valid_version_pre_build.to_s }
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
      subject { valid_version_pre.to_hash }
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
      subject { valid_version_build.to_hash }
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
      subject { valid_version_pre_build.to_hash }
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

    context 'Patch version Z (x.y.Z | x > 0) MUST be incremented \
    if only backwards compatible bug fixes are introduced. \
    A bug fix is defined as an internal change that fixes incorrect \
    behavior.' do

      [
        ['1.9.0',           '1.9.1'],
        ['1.9.1',           '1.9.2'],
        ['1.0.0-alpha',     '1.0.1'],
        ['1.0.0-alpha+001', '1.0.1']
      ].each do |(a, e)|
        it "When incremental_label is :patch, #{a}#up is to be #{e}." do
          actual = (SemanticVersioning::Version.new a).up
          expected = SemanticVersioning::Version.new e
          expect(actual).to eq expected
        end
      end
    end

    context 'Minor version Y (x.Y.z | x > 0) MUST be incremented \
    if new, backwards compatible functionality is introduced to \
    the public API.' do

      [
        ['1.9.0',                '1.10.0'],
        ['1.10.0',               '1.11.0'],
        ['1.0.0-alpha.1',        '1.1.0'],
        ['1.0.0+20130313144700', '1.1.0']
      ].each do |(a, e)|
        it "When incremental_label is :minor, #{a}#up is to be #{e}." do
          actual = (SemanticVersioning::Version.new a, :minor).up
          expected = SemanticVersioning::Version.new e, :minor
          expect(actual).to eq expected
        end
      end

      context 'It MAY include patch level changes. Patch version \
      MUST be reset to 0 when minor version is incremented.' do

        [
          ['1.9.1',   '1.10.0'],
          ['1.10.10', '1.11.0']
        ].each do |(a, e)|
          it "When incremental_label is :minor, #{a}#up is to be #{e}." do
            actual = (SemanticVersioning::Version.new a, :minor).up
            expected = SemanticVersioning::Version.new e, :minor
            expect(actual).to eq expected
          end
        end
      end
    end

    context 'Major version X (X.y.z | X > 0) MUST be incremented \
    if any backwards incompatible changes are introduced to the public API.' do

      [
        ['1.0.0',                      '2.0.0'],
        ['2.0.0',                      '3.0.0'],
        ['1.0.0-0.3.7',                '2.0.0'],
        ['1.0.0-beta+exp.sha.5114f85', '2.0.0']
      ].each do |(a, e)|
        it "When incremental_label is :major, #{a}#up is to be #{e}." do
          actual = (SemanticVersioning::Version.new a, :major).up
          expected = SemanticVersioning::Version.new e, :major
          expect(actual).to eq expected
        end
      end

      context 'Patch and minor version MUST be reset to 0 \
      when major version is incremented.' do

        [
          ['1.9.1',   '2.0.0'],
          ['2.10.10', '3.0.0']
        ].each do |(a, e)|
          it "When incremental_label is :major, #{a}#up is to be #{e}." do
            actual = (SemanticVersioning::Version.new a, :major).up
            expected = SemanticVersioning::Version.new e, :major
            expect(actual).to eq expected
          end
        end
      end
    end
  end

  describe '#up!' do

    context 'Patch version Z (x.y.Z | x > 0) MUST be incremented \
    if only backwards compatible bug fixes are introduced. \
    A bug fix is defined as an internal change that fixes incorrect \
    behavior.' do

      [
        ['1.9.0', '1.9.1'],
        ['1.9.1', '1.9.2'],
        ['1.0.0-alpha',     '1.0.1'],
        ['1.0.0-alpha+001', '1.0.1']
      ].each do |(a, e)|
        it "When incremental_label is :patch(default value), \
        #{a}#up! is to be #{e}." do
          actual   = SemanticVersioning::Version.new a
          actual.up!
          expected = SemanticVersioning::Version.new e
          expect(actual).to eq expected
        end
      end
    end

    context 'Minor version Y (x.Y.z | x > 0) MUST be incremented \
    if new, backwards compatible functionality is introduced to \
    the public API.' do

      [
        ['1.9.0',  '1.10.0'],
        ['1.10.0', '1.11.0'],
        ['1.0.0-alpha.1',        '1.1.0'],
        ['1.0.0+20130313144700', '1.1.0']
      ].each do |(a, e)|
        it "When incremental_label is :minor, #{a}#up! is to be #{e}." do
          actual   = SemanticVersioning::Version.new a, :minor
          actual.up!
          expected = SemanticVersioning::Version.new e, :minor
          expect(actual).to eq expected
        end
      end

      context 'It MAY include patch level changes. Patch version \
      MUST be reset to 0 when minor version is incremented.' do

        [
          ['1.9.1',   '1.10.0'],
          ['1.10.10', '1.11.0']
        ].each do |(a, e)|
          it "When incremental_label is :minor, #{a}#up! is to be #{e}." do
            actual   = SemanticVersioning::Version.new a, :minor
            actual.up!
            expected = SemanticVersioning::Version.new e, :minor
            expect(actual).to eq expected
          end
        end
      end
    end

    context 'Major version X (X.y.z | X > 0) MUST be incremented \
    if any backwards incompatible changes are introduced to the public API.' do

      [
        ['1.0.0', '2.0.0'],
        ['2.0.0', '3.0.0'],
        ['1.0.0-0.3.7',                '2.0.0'],
        ['1.0.0-beta+exp.sha.5114f85', '2.0.0']
      ].each do |(a, e)|
        it "When incremental_label is :major, #{a}#up! is to be #{e}." do
          actual   = SemanticVersioning::Version.new a, :major
          actual.up!
          expected = SemanticVersioning::Version.new e, :major
          expect(actual).to eq expected
        end
      end

      context 'Patch and minor version MUST be reset to 0 \
      when major version is incremented.' do

        [
          ['1.9.1',   '2.0.0'],
          ['2.10.10', '3.0.0']
        ].each do |(a, e)|
          it "When incremental_label is :minor, #{a}#up! is to be #{e}." do
            actual   = SemanticVersioning::Version.new a, :major
            actual.up!
            expected = SemanticVersioning::Version.new e, :major
            expect(actual).to eq expected
          end
        end
      end
    end
  end

  describe '#<=>' do

    it 'String Object is a invalid parameter.' do
      expect(valid_version <=> '1.2.3').to eq nil
    end

    context 'Precedence MUST be calculated by separating the version \
    into major, minor, patch and pre-release identifiers in that order. \
    Precedence is determined by the first difference when comparing each \
    of these identifiers from left to right as follows: \
    Major, minor, and patch versions are always compared numerically.' do
      [
        ['1.2.3', '1.2.3']
      ].each do |(a, e)|
        it "Comparing '#{a}' and '#{e}' is returned 0." do
          actual   = SemanticVersioning::Version.new a
          expected = SemanticVersioning::Version.new e
          expect(actual <=> expected).to eq 0
        end
      end

      [
        ['1.0.0', '2.0.0'],
        ['2.0.0', '2.1.0'],
        ['2.1.0', '2.1.1']
      ].each do |(a, e)|
        it "Comparing '#{a}' and '#{e}' is returned a negative value." do
          actual   = SemanticVersioning::Version.new a
          expected = SemanticVersioning::Version.new e
          expect(actual <=> expected).to be < 0
        end
      end

      [
        ['2.1.1', '2.1.0']
      ].each do |(a, e)|
        it "Comparing '#{a}' and '#{e}' is returned a regular value." do
          actual   = SemanticVersioning::Version.new a
          expected = SemanticVersioning::Version.new e
          expect(actual <=> expected).to be > 0
        end
      end

      context 'Build metadata SHOULD be ignored when determining version \
      precedence. Thus two versions that differ only in the build metadata, \
      have the same precedence. \
      Build metadata does not figure into precedence.' do
        [
          ['1.0.0',       '1.0.0+001'],
          ['1.0.0-alpha', '1.0.0-alpha+001'],
          ['1.0.0-alpha', '1.0.0-alpha+20130313144700'],
          ['1.0.0-beta',  '1.0.0-beta+exp.sha.5114f85']
        ].each do |(a, e)|
          it "Comparing '#{a}' and '#{e}' is returned 0." do
            actual   = SemanticVersioning::Version.new a
            expected = SemanticVersioning::Version.new e
            expect(actual <=> expected).to eq 0
          end
        end
      end
    end

    context 'When major, minor, and patch are equal, \
    a pre-release version has lower precedence than a normal version.' do
      [
        ['1.0.0', '1.0.0-alpha']
      ].each do |(a, e)|
        it "Comparing '#{a}' and '#{e}' is returned a regular value." do
          actual   = SemanticVersioning::Version.new a
          expected = SemanticVersioning::Version.new e
          expect(actual <=> expected).to be > 0
        end
      end
    end

    context 'Precedence for two pre-release versions with the same major, \
    minor, and patch version MUST be determined by comparing each dot \
    separated identifier from left to right until a difference is found \
    as follows: identifiers consisting of only digits are compared numerically \
    and identifiers with letters or hyphens are compared lexically in ASCII \
    sort order. Numeric identifiers always have lower precedence than \
    non-numeric identifiers. A larger set of pre-release fields has a higher \
    precedence than a smaller set, \
    if all of the preceding identifiers are equal.' do

      [
        ['1.0.0-alpha',      '1.0.0-alpha.1'],
        ['1.0.0-alpha.1',    '1.0.0-alpha.beta'],
        ['1.0.0-alpha.beta', '1.0.0-beta'],
        ['1.0.0-beta.2',     '1.0.0-beta.11'],
        ['1.0.0-rc.1',       '1.0.0'],
        ['1.0.0-alpha',      '1.0.0']
      ].each do |(a, e)|
        it "Comparing '#{a}' and '#{e}' is returned a negative value." do
          actual   = SemanticVersioning::Version.new a
          expected = SemanticVersioning::Version.new e
          expect(actual <=> expected).to be < 0
        end
      end

      [
        ['1.0.0-alpha.1', '1.0.0-alpha']
      ].each do |(a, e)|
        it "Comparing '#{a}' and '#{e}' is returned a negative value." do
          actual   = SemanticVersioning::Version.new a
          expected = SemanticVersioning::Version.new e
          expect(actual <=> expected).to be > 0
        end
      end
    end
  end
end
