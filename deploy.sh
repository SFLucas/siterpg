git add . &&
git commit -m "$1" &&
git push origin master &&
ssh root@51.77.214.19 <<EOF
cd siterpg &&
git pull origin master &&
stack build &&
lsof -i:443 -Fp | sed 's/^p//' | head -n -1 | xargs kill -9;
nohup stack exec aulahaskell > /dev/null
echo "deploy finished"
EOF