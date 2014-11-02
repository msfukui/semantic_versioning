# SemanticVersioning

セマンティック バージョニング（Semantic Versioning）を取り扱う Utility Class を提供します。
セマンティック バージョニングについて詳しくは以下のサイトを参照してください。
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

```ruby
require 'semantic_versioning'

v = SemanticVersioning.new '1.2.3'

v.to_s  #  => '1.2.3'
v.major #  => 1
v.minor #  => 2
v.patch #  => 3

v.incremental_label = :patch # default
v.up    # => '1.2.4'

v.incremental_label = :minor
v.up    # => '1.3.0'

v.incremental_label = :major
v.up    # => '2.2.0'

```

```bin
$ version_increment 1.2.3 patch
1.2.4
```

## Contributing

1. Fork it ( https://github.com/msfukui/semantic_versioning/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Acknowledgment

セマンティック バージョニングについて素晴らしい仕様書を無償で公開いただいている Tom Preston-Werner さんと、その素晴らしい日本語訳をとてもわかりやすく公開いただいている shijimiii さんに感謝します。

## License

本プログラムのライセンスは MIT License です。
詳細は [LICENSE.txt](LICENSE.txt) を参照してください。

[EOF]
