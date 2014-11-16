# SemanticVersioning

[![Build Status](https://travis-ci.org/msfukui/semantic_versioning.svg)](https://travis-ci.org/msfukui/semantic_versioning)

## Attension!

rubygems.org で公開されている以下のものとは全く別物です!

探されていた方はごめんなさい。m_o_m

[semantic_versioning](https://github.com/joecorcoran/semantic_versioning)

## What's this?

セマンティック バージョニング（Semantic Versioning）を取り扱う Class とバージョン・インクリメント用のコマンドを提供します。

セマンティック バージョニングの仕様については以下のサイトを参照してください。

[semantic_versioning](http://semver.org)

[semantic_versioning(日本語訳)](http://shijimiii.info/technical-memo/semver)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'semantic_versioning'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install semantic_versioning

## Usage

ruby gems

```ruby
require 'semantic_versioning'

v = SemanticVersioning::Version.new '1.2.3'

v.to_s     # => '1.2.3'
v.to_a     # => [1, 2, 3]
v.to_hash  # => { major: 1, minor: 2, patch: 3 }
v.major    # => 1
v.minor    # => 2
v.patch    # => 3

v.incremental_label = :patch # default
v.up       # => '1.2.4'

v.incremental_label = :minor
v.up       # => '1.3.0'

v.incremental_label = :major
v.up       # => '2.0.0'

v1  = SemanticVersioning::Version.new '1.2.3'
v2  = SemanticVersioning::Version.new '1.2.4'
v11 = SemanticVersioning::Version.new '1.2.3'

v1 > v2    # => false
v1 >= v2   # => false
v1 > v2    # => true
v1 >= v2   # => true
v1 == v2   # => false
v1 == v11  # => true

```

command

```sh
$ increment_version patch 1.2.3
1.2.4
$ increment_version minor 1.2.4
1.3.0
$ increment_version major 1.3.0
2.0.0
```

## TODO

* Corresponding to the pre-release and the build metadata string.

Please refer to the [issue](https://github.com/msfukui/semantic_versioning/issues) for more information.

## Contributing

1. Fork it ( https://github.com/msfukui/semantic_versioning/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Acknowledgment

セマンティック バージョニングについて説明した素晴らしい仕様書を公開いただいている Tom Preston-Werner さんと、その素晴らしい日本語訳をとてもわかりやすく公開いただいている shijimiii さんに感謝します。

## License

本プログラムのライセンスは MIT License で提供します。

詳細は [LICENSE.txt](LICENSE.txt) を参照してください。

[EOF]
