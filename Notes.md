11) tag system

# Creating a Helm Chart Repository using Github Actions

## The git repo destination should be public or enterprise to have gh-pages option available

```bash
helm git clone https://github.com/helm/charts-repo-cations-demo.git
helm cd charts-repo-actions-demo
git remove origin
# Redirect to your repo
git remote add origin git@github.com:oliveirajoaop/template.git
```

- Create one empty repo named charts
  - Then continue the process to get the template files clean

```bash
git remote add origin git@github.com:oliveirajoaop/template.git
git checkout --orphan gh-pages
```

- Get a fresh brank helm

```bash
rm -rf *
```

- Disable git hub actions in gh_pages and also remove the .gitignore file

```bash
rm -rf .github
rm -rf .gitignore
```

- Commit changes

```bash
git add . --all
git commit -sm 'empty gh-pages branch'
```

- You now have a template repo for you helm release tagging
- Create an index.html (Optional?)

```bash
touch index.html
vim index.html # Make it simple for now and fill with something
git add .
git commit -sm 'index html'
git push origin gh-pages
```

- Switch to master branch

```bash
git checkout main
```

- Check if you have changes and push them

```bash
git status
```

- Create a new branch and add your charts (charts/<chart_name>)

```bash
git checkout -b <branch_name_or_chart_name>
```

- Copy your chart

```bash
cp <chart_name> <destination_chart_folder>
```

- Push the chart to the repo

```bash
git add .
git commit -m 'add <chart_name>'
git push origin <chart_name>
```

- Before creating the pull request in the link provided (points to github) check your access tokens if you have none you will need to create one
- Go to repo, settings, personal access token, generate a new token, copy the token and create a secret under your chart repo. (optional)
- Go to the chats repo, setings, secrets, add a new secret (CR_Token) paste the secret and create
- Next you will have to confir you have github pages enabled
- Go to settings, scroll down and in GitHub Pages select the gh-pages branch from the drop down list in Source, and you can add your custom domain that could point to index.html created earlier or other page
- Now create the pull request and wait for the tests to run and complete (fix errors first if any and push again)
- Then merge the pull request
- Add, update and install your helm repo

```bash
helm repo add <chart_name> <chart_link>
helm repo update
helm install <chart_name> <chart_link>
```

## Tags Versioning

- Create a new tag on github in tags (0.1.0) First Release
- Go to your repo, actions, new workflow, select a blank template and paste the code form the example below or [here](https://github.com/marketplace/actions/github-tag-bump)

```bash
name: Bump version
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-22.04
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: '0'

    - name: Bump version and push tag
      uses: anothrNick/github-tag-action@1.17.2 # Don't use @master unless you're happy to test the latest version
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        WITH_V: false
```

- Rename the work flow to bump.yaml for instance
- Change the WITH_V: from true (v0.1.0) to false (0.1.0) if you do not wish to have a v in the tag version
- Commit to the master branch

## For minor version release Tags

- Update your code
- Commit to a new branch
- Name it minor and propose file change
- Create the merge pull request
- Use the title and add ' #minor' to the end
- Confirm merge
- GitHub Actions can automate your releases from your git commit messages - conventional commits
  - Making use of commit messages
    - chore (major???)
    - feat (feature will bump the second digit 0.X.0, which is the minor version)
    - fix (fix will bump the third digit 0.0.X, which is the fix version)
    - docs (????)

## Initial commit with tags

```bash
# Add a tag and comment (Optional)
git tag -a 0.0.0 -m "Initial tagging"
# List existing tags
git tag --list
# Push tag release to the repo
git push --tags
```

- To see how the below command will work

```bash
git push --follow-tags origin main
```

## Understanding Semantic Versioning

- Format will be Major.Minor.Patch and also alpha/beta (not production ready) (X.X.X-alpha)
  - Major (1.0.0)
    - Incompatible with previous versions
    - Fundaqtional changes
  - Minor (0.1.0)
    - Adding functionallity
    - Backwards compatible
  - Patch (0.0.1)
    - Backwards compatible
    - Bug fixes

## Notes:

- [Git hub Actions create release](https://github.com/actions/create-release)
- [How to use Github Actions to automate Git tags management](https://www.youtube.com/watch?v=luUNsPKry3I)
- [GitHub Tag Bump](https://github.com/marketplace/actions/github-tag-bump)
- [Automate Helm chart repository publishing with GitHub Actions and Pages](https://www.youtube.com/watch?v=fX2TWxl64yQ)
- [Creating a Helm Chart Repository using Github Actions](https://www.youtube.com/watch?v=hL-8Jn5RTmw)

## Helm reconcile strategy options

- --reconcile-strategy        -- the reconcile strategy for helm chart created by the helm release(accepted values: Revision and ChartRevision)

##  Clone a repo and remove origin and change it to your repo

```bash
git remove origin
git remote add origin git@github.com:<repo_owner>/<repo_name>
git remote add origin git@github.com:oliveirajoaop/flux
```

## Slack set var for notifications and slack notification

```bash
$ SLACK=https://hooks.slack.com/services/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
$ kubectl -n flux-system create secret generic slack-url \
--from-literal=address=${SLACK}
```


export $(cat .env)
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/oliveirajoaop/v1/git/refs \
  -d '{"ref":"refs/heads/featureA","sha":"aa218f56b14c9653891f9e74264a383fa43fefbd"}'

