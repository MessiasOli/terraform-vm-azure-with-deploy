echo "Cheking directories to tmp."

if [ ! -d "tmp" ]; then
  mkdir tmp
fi

sudo git clone https://github.com/MessiasOli/react-portifolio.git ./tmp/react-portifolio/
cd ./tmp/react-portifolio
sudo npm install && npm run build
cd ..
cd ..

echo "Build completed with SUCCESS!"
