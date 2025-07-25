# pre-commit

We run [pre-commit](https://pre-commit.com/) with GitHub Actions so installation on
your local machine is currently optional.

The pre-commit [configuration file](https://github.com/apache/tooling-docs/blob/main/.pre-commit-config.yaml)
is in the repository root. Before you can run the hooks, you need to have pre-commit installed.

The hooks run when running `git commit` and also from the command line with `pre-commit`. Some of the hooks will auto
fix the code after the hooks fail whilst most will print error messages from the linters. If a hook fails the overall
commit will fail, and you will need to fix the issues or problems and `git add` and `git commit` again. On `git commit`
the hooks will run mostly only against modified files so if you want to test all hooks against all files and when you
are adding a new hook you should always run:

`pre-commit run --all-files`

Sometimes you might need to skip a hook to commit because the hook is stopping you from committing or your computer
might not have all the installation requirements for all the hooks. The `SKIP` variable is comma separated for two or
more hooks:

`SKIP=typos git commit -m "foo"`

The same applies when running pre-commit:

`SKIP=typos pre-commit run --all-files`

Occasionally you can have more serious problems when using `pre-commit` with `git commit`. You can use `--no-verify` to
commit and stop `pre-commit` from checking the hooks. For example:

`git commit --no-verify -m "foo"`

If you just want to run one hook for example just run the `markdownlint` hook:

`pre-commit run markdownlint --all-files`

We have a [Makefile](https://github.com/apache/tooling-docs/blob/main/Makefile) in the repository root which has three pre-commit convenience commands.

For example, you can run the following to set up pre-commit to run before each commit

```shell
make checkinstall
```
