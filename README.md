### 配置说明

- 本项目使用motoko-sequence（https://github.com/matthewhammer/motoko-sequence）作为日志数据的存储，需要引用motoko包管理工具：vessel（https://github.com/dfinity/vessel），部署项目前要先修改相关vessel配置

- 1. 安装vessel

    ```
  ./scripts/vessel-install.sh
    ```

    验证vessel安装：

    ```
  $ vessel --version
  # vessel 0.6.2
    ```

    如果提示找不到vessel，把vessel所在路径配置到`PATH`环境变量

- 2. 在项目根目录下增加vessel.dhall文件，写上引用的motoko包，或者运行`vessel init`初始化项目

    ```
  {
  dependencies = [ "base", "sequence"],
  compiler = None Text
  }
    ```

- 3. 在项目根目录下增加package-set.dhall文件，写上引用的motoko包对应的信息

    ```
  ...
  additions = [
    { name = "base"
    , repo = "https://github.com/dfinity/motoko-base"
    , version = "dfx-0.7.2"
    , dependencies = [] : List Text
    },
    
    { name = "sequence"
    , repo = "https://github.com/matthewhammer/motoko-sequence"
    , version = "master"
    , dependencies = [] : List Text
    }
  ]
  ...
    ```

- 4. 修改dfx.json文件中defaults->build->packtool to say `"vessel sources"` 如下：

    ```
   ...
   "defaults": {
     "build": {
       "packtool": "vessel sources"
     }
   }
   ...
    ```

- 5. 然后运行 `dfx build` 或者 `dfx deploy`。

# League

Dfx version 0.8.0

Start the Internet Computer network on your local computer in your second terminal by running the following command:

```
yarn install
dfx start
```

Deploy Application

```
dfx deploy
```

Visit:

Append `/?canisterId=` and the `league_assets` identifier to the URL.

For example, the full URL should look similar to the following:

http://127.0.0.1:8000/?canisterId=ryjl3-tyaaa-aaaaa-aaaba-cai

**or**

```
npm start
```

visit：http://localhost:8080/

## Troubleshooting

### Missing node signing public key

Restart the DFX network with:

```
dfx start --clean
```

The `--clean` option removes checkpoints and stale state information from your project’s cache so that you can restart the Internet Computer replica and web server processes in a clean state.

### How to upgrade the SDK

To upgrade from a previous SDK version, run:

```
dfx upgrade
```

For a clean installation instead of an upgrade, run:

```
~/.cache/dfinity/uninstall.sh && sh -ci "$(curl -sSL https://sdk.dfinity.org/install.sh)"
```

[vue]: https://vuejs.org/
[sdk]: https://sdk.dfinity.org/docs/index.html
[project]: https://sdk.dfinity.org/docs/developers-guide/tutorials/explore-templates.html
[vuetify]: https://vuetifyjs.com/