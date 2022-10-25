### Git subtree
git remote add spree-upstream git@github.com:spree/spree.git
git subtree add --prefix=spree/ spree-upstream master --squash
