function gz_git_init
    npm init
    npm install --save-dev @commitlint/{config-conventional,cli}
    npm install --save-dev cz-conventional-changelog 
    commitizen init cz-conventional-changelog --save-dev --save-exact
    echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
    npm install --save-dev husky
    echo '"husky": { "hooks": { "pre-commit": "pretty-quick --staged", "commit-msg": "commitlint -E HUSKY_GIT_PARAMS" } }' | cb
    echo "husky copied Please paste it in package.json"
    echo 'also : "commit":"git cz"'
end
