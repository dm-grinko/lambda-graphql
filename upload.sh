cd ./lambdas
rm lambda-apollo.zip
rm lambda-python.zip
cd ./lambda-apollo
rm -rf ./build
npm run build
cd ../../terraform
terraform destroy -var-file=variables.tfvars -auto-approve
terraform apply -var-file=variables.tfvars -auto-approve