# Procedures JS Notes

1. These are templated javascript files and can't be complied directly as javascript
2. The $$ are escaped dollar signs in order render in the final script `${VAR_NAME}`, we'll need to use `$${VAR_NAME}` in the templated JS file. Terraform will resolve it as expected before using it in the procedure definition.
