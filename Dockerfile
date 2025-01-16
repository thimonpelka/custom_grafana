# Use the official grafana image. Specific version set so that we can control when to upgrade
FROM grafana/grafana:11.4.0

# Expose Grafana default port
EXPOSE 3000

USER root


# ---- AUTH: ----
# Disable the login
ENV GF_SECURITY_ADMIN_USER=admin
ENV GF_SECURITY_ADMIN_PASSWORD=admin
# ENV GF_AUTH_DISABLE_LOGIN_FORM=true
ENV GF_AUTH_ANONYMOUS_ENABLED=true
ENV GF_AUTH_BASIC_ENABLED=false


# ---- OTHER: ----
# Set this to true if actionable HTML tags (button, script, etc.) are needed
ENV GF_PANELS_DISABLE_SANITIZE_HTML=true


# ---- FAVICON: ----
# Set the favicon to our company logo
COPY img/favicon-32x32.png /usr/share/grafana/public/img/fav32.png
COPY img/favicon-32x32.png /usr/share/grafana/public/img/apple-touch-icon.png
COPY img/logo.svg /usr/share/grafana/public/img/grafana_icon.svg


# ---- UI: ----
# Set the default theme to dark
ENV GF_USERS_DEFAULT_THEME=dark

ENV GF_EXPLORE_ENABLED=false
ENV GF_ALERTING_ENABLED=false
ENV GF_UNIFIED_ALERTING_ENABLED=false

# ---- DASHBOARDS: ----
# Overwrite home dashboard
COPY dashboards/ /usr/share/grafana/public/dashboards/

# ---- DATSOURCES: ----
COPY datasources/ /usr/share/grafana/conf/provisioning/datasources/

# ---- APP TITLE: ----
# This works, however the name gets instantly overwritten by the javascript code. Therefore we need the following line as well
RUN sed -i 's|<title>\[\[.AppTitle]]<\/title>|<title>Process Data<\/title>|g' /usr/share/grafana/public/views/index.html;
# Overwrites the variable name of the title
RUN sed -i 's|AppTitle="Grafana"|AppTitle="Process Data"|g' /usr/share/grafana/public/build/*.js;

RUN sed -i 's|LoginTitle="Welcome to Grafana"|LoginTitle="Process Data Suite"|g' /usr/share/grafana/public/build/*.js;


# Tip to find the correct file to edit: go to routes.tsx and search for the route you want to edit. Then search for the file in the public folder

# THIS DOES NOT WORK. THE PROJECT WOULD HAVE TO BE BUILT AGAIN
RUN sed -i 's|return (|return (<span>test</span>|g' /usr/share/grafana/public/app/features/browse-dashboards/BrowseDashboardsPage.tsx;


