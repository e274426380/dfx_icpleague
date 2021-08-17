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