#!/bin/bash
docker exec -i fhoss sh <<'SH'
set -e
for CONF in \
  /opt/OpenIMSCore/FHoSS/deploy/conf/tomcat-users.xml \
  /opt/OpenIMSCore/FHoSS/tomcat/conf/tomcat-users.xml
do
  [ -f "$CONF" ] || continue
  cp "$CONF" "$CONF.bak"

  # ensure the admin roles exist
  grep -q 'rolename="hss_admin"' "$CONF" || sed -i '/rolename="hss_user"/a \  <role rolename="hss_admin"/>' "$CONF"
  grep -q 'rolename="admin"' "$CONF"     || sed -i '$i \  <role rolename="admin"/>' "$CONF"

  # old FHoSS/Tomcat accepts <user name="...">; also keep <user username="..."> in sync
  if grep -q '<user name="hss"' "$CONF"; then
    sed -i 's#<user name="hss"[^>]*/>#<user name="hss" password="hss" roles="hss_user,hss_admin,admin"/>#' "$CONF"
  fi
  if grep -q '<user username="hss"' "$CONF"; then
    sed -i 's#<user username="hss"[^>]*/>#<user username="hss" password="hss" roles="hss_user,hss_admin,admin"/>#' "$CONF"
  fi

  echo "Updated $CONF"
done
SH

docker restart fhoss

