# use sensible defaults if any of these are missing
if [ -z "$CA_NAME" ]; then readonly ca_name="demo-ca"; else readonly ca_name="$CA_NAME"; fi
if [ -z "$NAME" ]; then readonly name="demo-server"; else readonly name="$NAME"; fi
if [ -z "$FILE_NAME" ]; then readonly file_name="$name"; else readonly file_name="$FILE_NAME"; fi
if [ -z "$SAN_NAMES" ]; then readonly san_names=""; else readonly san_names="$SAN_NAMES"; fi

echo -e "\e[1;34mca_name=\e[1;32m$ca_name\e[0m"
echo -e "\e[1;34mname=\e[1;32m$name\e[0m"
echo -e "\e[1;34mfile_name=\e[1;32m$file_name\e[0m"
echo -e "\e[1;34msan_names=\e[1;32m$san_names\e[0m"

isNumber="^[0-9]+$"

if [[ "$CA_CRT_NUM_DAYS" =~ $isNumber ]]; then readonly ca_crt_num_days=$CA_CRT_NUM_DAYS; else readonly ca_crt_num_days=30; fi
if [[ "$CA_KEY_NUM_BITS" =~ $isNumber ]]; then readonly ca_key_num_bits=$CA_KEY_NUM_BITS; else readonly ca_key_num_bits=4096; fi
if [[ "$CRT_NUM_DAYS" =~ $isNumber ]]; then readonly crt_num_days=$CRT_NUM_DAYS; else readonly crt_num_days=30; fi
if [[ "$KEY_NUM_BITS" =~ $isNumber ]]; then readonly key_num_bits=$KEY_NUM_BITS; else readonly key_num_bits=4096; fi

echo -e "\e[1;34mca_crt_num_days=\e[1;32m$ca_crt_num_days\e[0m"
echo -e "\e[1;34mca_key_num_bits=\e[1;32m$ca_key_num_bits\e[0m"
echo -e "\e[1;34mcrt_num_days=\e[1;32m$crt_num_days\e[0m"
echo -e "\e[1;34mkey_num_bits=\e[1;32m$key_num_bits\e[0m"

isBoolean="^(true|false)$"

if [[ "$EXPORT_CA_CRT_FILE" =~ $isBoolean ]]; then readonly export_ca_crt_file=$EXPORT_CA_CRT_FILE; else readonly export_ca_crt_file=false; fi
if [[ "$EXPORT_CA_KEY_FILE" =~ $isBoolean ]]; then readonly export_ca_key_file=$EXPORT_CA_KEY_FILE; else readonly export_ca_key_file=false; fi
if [[ "$EXPORT_CA_PFX_FILE" =~ $isBoolean ]]; then readonly export_ca_pfx_file=$EXPORT_CA_PFX_FILE; else readonly export_ca_pfx_file=true; fi
if [[ "$EXPORT_CRT_FILE" =~ $isBoolean ]]; then readonly export_crt_file=$EXPORT_CRT_FILE; else readonly export_crt_file=false; fi
if [[ "$EXPORT_KEY_FILE" =~ $isBoolean ]]; then readonly export_key_file=$EXPORT_KEY_FILE; else readonly export_key_file=false; fi
if [[ "$EXPORT_PFX_FILE" =~ $isBoolean ]]; then readonly export_pfx_file=$EXPORT_PFX_FILE; else readonly export_pfx_file=false; fi
if [[ "$PFX_INCLUDE_CHAIN" =~ $isBoolean ]]; then readonly pfx_include_chain=$PFX_INCLUDE_CHAIN; else readonly pfx_include_chain=false; fi
if [[ "$UNENCRYPTED_KEY" =~ $isBoolean ]]; then readonly unencrypted_key=$UNENCRYPTED_KEY; else readonly unencrypted_key=false; fi

echo -e "\e[1;34mexport_ca_crt_file=\e[1;32m$export_ca_crt_file\e[0m"
echo -e "\e[1;34mexport_ca_key_file=\e[1;32m$export_ca_key_file\e[0m"
echo -e "\e[1;34mexport_ca_pfx_file=\e[1;32m$export_ca_pfx_file\e[0m"
echo -e "\e[1;34mexport_crt_file=\e[1;32m$export_crt_file\e[0m"
echo -e "\e[1;34mexport_key_file=\e[1;32m$export_key_file\e[0m"
echo -e "\e[1;34mexport_pfx_file=\e[1;32m$export_pfx_file\e[0m"
echo -e "\e[1;34mpfx_include_chain=\e[1;32m$pfx_include_chain\e[0m"
echo -e "\e[1;34munencrypted_key=\e[1;32m$unencrypted_key\e[0m"

readonly ca_pfx_external_file_path="/tmp/certs/$ca_name.pfx"
if [ -f "$ca_pfx_external_file_path" ]; then readonly ca_pfx_external_file_exists=true; else readonly ca_pfx_external_file_exists=false; fi

echo -e "\e[1;34mca_pfx_external_file_path=\e[1;35m$ca_pfx_external_file_path\e[0m"
echo -e "\e[1;34mca_pfx_external_file_exists=\e[1;35m$ca_pfx_external_file_exists\e[0m"

# generate passwords if not supplied

generate_password () {
    local password=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
    echo "$password"
}

if [ -z "$CA_KEY_PASSWORD" ]
then
    readonly ca_key_password="$(generate_password)"
    readonly ca_key_password_generated=true
else
    readonly ca_key_password="$CA_KEY_PASSWORD"
    readonly ca_key_password_generated=false
fi

echo -e "\e[1;34mca_key_password_generated=\e[1;35m$ca_key_password_generated\e[0m"

if [ -z "$CA_PFX_PASSWORD" ]
then
    readonly ca_pfx_password="$(generate_password)"
    readonly ca_pfx_password_generated=true
else
    readonly ca_pfx_password="$CA_PFX_PASSWORD"
    readonly ca_pfx_password_generated=false
fi

echo -e "\e[1;34mca_pfx_password_generated=\e[1;35m$ca_pfx_password_generated\e[0m"

if [ -z "$KEY_PASSWORD" ]
then
    readonly key_password="$(generate_password)"
    readonly key_password_generated=true
else
    readonly key_password="$KEY_PASSWORD"
    readonly key_password_generated=false
fi

echo -e "\e[1;34mkey_password_generated=\e[1;35m$key_password_generated\e[0m"

if [ -z "$PFX_PASSWORD" ]
then
    readonly pfx_password="$(generate_password)"
    readonly pfx_password_generated=true
else
    readonly pfx_password="$PFX_PASSWORD"
    readonly pfx_password_generated=false
fi

echo -e "\e[1;34mpfx_password_generated=\e[1;35m$pfx_password_generated\e[0m"

if [ ! -f "/usr/lib/ssl/openssl.cnf" ]
then
    echo -e "\e[1;34minstalling tools...\e[0m"

    # install openssl and ca-certificates
    apt-get update
    apt-get --yes install openssl
    apt-get --yes install ca-certificates

    echo -e "\e[1;34mtools installed\e[0m"
fi

# create temp files
readonly ca_crt_file_path="$(mktemp)"
readonly ca_ext_file_path="$(mktemp)"
readonly ca_key_file_path="$(mktemp)"
readonly ca_pfx_file_path="$(mktemp)"

if [ "$ca_pfx_external_file_exists" = true ]
then
    echo -e "\e[1;34mreusing CA certificate\e[0m"

    # copy the CA pfx into the container
    cp "$ca_pfx_external_file_path" "$ca_pfx_file_path"
    # save the CA certificate internally
    openssl pkcs12 -in "$ca_pfx_file_path" -nokeys -out "$ca_crt_file_path" -passin pass:"$ca_pfx_password"
    # save the CA key internally
    openssl pkcs12 -in "$ca_pfx_file_path" -nocerts -out "$ca_key_file_path" -passin pass:"$ca_pfx_password" -passout pass:"$ca_key_password"

    readonly new_ca_files=false
else
    echo -e "\e[1;34mcreating CA certificate\e[0m"

    # setup the config file for CA certificate creation
    printf "[ req ]\n" > "$ca_ext_file_path"
    printf "distinguished_name=req_distinguished_name\n" >> "$ca_ext_file_path"
    printf "x509_extensions=v3_ca\n" >> "$ca_ext_file_path"
    printf "[ req_distinguished_name ]\n" >> "$ca_ext_file_path"
    printf "[ v3_ca ]\n" >> "$ca_ext_file_path"
    printf "subjectKeyIdentifier=hash\n" >> "$ca_ext_file_path"
    printf "authorityKeyIdentifier=keyid:always,issuer\n" >> "$ca_ext_file_path"
    printf "basicConstraints=critical,CA:true\n" >> "$ca_ext_file_path"
    printf "keyUsage=keyCertSign, cRLSign\n" >> "$ca_ext_file_path"

    # generate and save the CA certificate and CA key
    openssl req -days "$ca_crt_num_days" -config "$ca_ext_file_path" -keyout "$ca_key_file_path" -newkey rsa:"$ca_key_num_bits" -out "$ca_crt_file_path" -passout pass:"$ca_key_password" -subj "/CN=$ca_name" -x509
    # convert and save the CA certificate and CA key to a pfx
    openssl pkcs12 -export -in "$ca_crt_file_path" -inkey "$ca_key_file_path" -out "$ca_pfx_file_path" -passin pass:"$ca_key_password" -passout pass:"$ca_pfx_password"

    readonly new_ca_files=true
fi

echo -e "\e[1;34mnew_ca_files=\e[1;35m$new_ca_files\e[0m"

# ensure that the CA certificate is implicitly trusted
echo -e "\e[1;34mtrusting CA certificate\e[0m"
cp "$ca_crt_file_path" "/usr/local/share/ca-certificates/$ca_name.crt"
update-ca-certificates

# create temp files
readonly crt_file_path="$(mktemp)"
readonly csr_file_path="$(mktemp)"
readonly ext_file_path="$(mktemp)"
readonly key_file_path="$(mktemp)"
readonly pfx_file_path="$(mktemp)"

# generate and save the (unsigned) server certificate and server key

if [ "$unencrypted_key" = true ]
then
    # unencrypted private key
    echo -e "\e[1;34mcreating server certificate (unencrypted private key)\e[0m"
    openssl genrsa -out "$key_file_path" "$key_num_bits"
    openssl req -key "$key_file_path" -new -out "$csr_file_path" -subj "/CN=$name"
else
    # encrypted private key
    echo -e "\e[1;34mcreating server certificate (encrypted private key)\e[0m"
    openssl req -keyout "$key_file_path" -new -newkey rsa:"$key_num_bits" -out "$csr_file_path" -passout pass:"$key_password" -subj "/CN=$name"
fi

# create a serial number file containing a randomly generated serial number
openssl rand -out "/tmp/tmp.srl" -hex 18

# setup the config file for server certificate creation
printf "subjectKeyIdentifier=hash\n" >> "$ext_file_path"
printf "authorityKeyIdentifier=keyid,issuer\n" >> "$ext_file_path"
printf "basicConstraints=CA:FALSE\n" > "$ext_file_path"
printf "keyUsage=nonRepudiation, digitalSignature, keyEncipherment\n" >> "$ext_file_path"
if [ "$san_names" != "" ]; then printf "subjectAltName=DNS:${san_names// /,DNS:}\n" >> "$ext_file_path"; fi

# sign and save the server certificate, adding any SAN names specified
echo -e "\e[1;34msigning server certificate\e[0m"
openssl x509 -CA "$ca_crt_file_path" -CAkey "$ca_key_file_path" -days "$crt_num_days" -extfile "$ext_file_path" -in "$csr_file_path" -out "$crt_file_path" -passin pass:"$ca_key_password" -req

# convert and save the (signed) server certificate and server key to a pfx

if [ "$unencrypted_key" = true ]
then
    # unencrypted private key
    if [ "$pfx_include_chain" = true ]
    then
        # include certificate chain
        echo -e "\e[1;34msaving server certificate (unencrypted key) to .pfx (including chain)\e[0m"
        openssl pkcs12 -chain -export -in "$crt_file_path" -inkey "$key_file_path" -out "$pfx_file_path" -passout pass:"$pfx_password"
    else
        # don't include certificate chain
        echo -e "\e[1;34msaving server certificate (unencrypted key) to .pfx (not including chain)\e[0m"
        openssl pkcs12 -export -in "$crt_file_path" -inkey "$key_file_path" -out "$pfx_file_path" -passout pass:"$pfx_password"
    fi
else
    # encrypted private key
    if [ "$pfx_include_chain" = true ]
    then
        # include certificate chain
        echo -e "\e[1;34msaving server certificate (encrypted key) to .pfx (including chain)\e[0m"
        openssl pkcs12 -chain -export -in "$crt_file_path" -inkey "$key_file_path" -out "$pfx_file_path" -passin pass:"$key_password" -passout pass:"$pfx_password"
    else
        # don't include certificate chain
        echo -e "\e[1;34msaving server certificate (encrypted key) to .pfx (not including chain)\e[0m"
        openssl pkcs12 -export -in "$crt_file_path" -inkey "$key_file_path" -out "$pfx_file_path" -passin pass:"$key_password" -passout pass:"$pfx_password"
    fi
fi

# optionally copy files so that they are available outside of the container
# if a file is being exported and its password (if applicable) was generated then it will be written to a corresponding .pwd file

if [ "$new_ca_files" = true ]
then
    if [ "$export_ca_crt_file" = true ]
    then
        cp "$ca_crt_file_path" "/tmp/certs/$ca_name.crt"
        echo -e "\e[1;34msaved CA .crt to host as \e[1;32m$ca_name.crt\e[0m"
    fi

    if [ "$export_ca_key_file" = true ]
    then
        cp "$ca_key_file_path" "/tmp/certs/$ca_name.key"
        echo -e "\e[1;34msaved CA .key to host as \e[1;32m$ca_name.key\e[0m"

        if [ "$ca_key_password_generated" = true ]
        then
            printf "$ca_key_password" > "/tmp/certs/$ca_name.key.pwd"
            echo -e "\e[1;34msaved CA .key password to host as \e[1;32m$ca_name.key.pwd\e[0m"
        fi
    fi

    if [ "$export_ca_pfx_file" != false ]
    then
        cp "$ca_pfx_file_path" "$ca_pfx_external_file_path"
        echo -e "\e[1;34msaved CA .pfx to host as \e[1;32m$ca_name.pfx\e[0m"

        if [ "$ca_pfx_password_generated" = true ]
        then
            printf "$ca_pfx_password" > "$ca_pfx_external_file_path.pwd"
            echo -e "\e[1;34msaved CA .pfx password to host as \e[1;32m$ca_name.pfx.pwd\e[0m"
        fi
    fi
fi

if [ "$export_crt_file" = true ]
then
    cp "$crt_file_path" "/tmp/certs/$file_name.crt"
    echo -e "\e[1;34msaved server .crt to host as \e[1;32m$file_name.crt\e[0m"
fi

if [ "$export_key_file" = true ]
then
    cp "$key_file_path" "/tmp/certs/$file_name.key"
    echo -e "\e[1;34msaved server .key to host as \e[1;32m$file_name.key\e[0m"

    if [ "$key_password_generated" = true ] && [ "$unencrypted_key" = false ]
    then
        printf "$key_password" > "/tmp/certs/$file_name.key.pwd"
        echo -e "\e[1;34msaved server .key password to host as \e[1;32m$file_name.key.pwd\e[0m"
    fi
fi

if [ "$export_pfx_file" = true ]
then
    cp "$pfx_file_path" "/tmp/certs/$file_name.pfx"
    echo -e "\e[1;34msaved server .pfx to host as \e[1;32m$file_name.pfx\e[0m"

    if [ "$pfx_password_generated" = true ]
    then
        printf "$pfx_password" > "/tmp/certs/$file_name.pfx.pwd"
        echo -e "\e[1;34msaved server .pfx password to host as \e[1;32m$file_name.pfx.pwd\e[0m"
    fi
fi

rm "$ca_crt_file_path" "$ca_ext_file_path" "$ca_key_file_path" "$ca_pfx_file_path"
echo -e "\e[1;34mremoved interim CA certificate files\e[0m"
rm "$crt_file_path" "$csr_file_path" "$ext_file_path" "$key_file_path" "$pfx_file_path"
echo -e "\e[1;34mremoved interim server certificate files\e[0m"
rm "/usr/local/share/ca-certificates/$ca_name.crt" "/tmp/tmp.srl"
echo -e "\e[1;34mremoved other interim certificate files\e[0m"