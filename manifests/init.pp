class nginx {
	package { nginx: ensure => installed, require => Class["aptsources"] }

	service { "nginx":
		ensure => running,
		require => Package["nginx"],
		hasrestart => true
	}

	file {
		"/etc/nginx/sites-enabled/default":
			require => Package["nginx"],
			ensure => absent,
			notify => Service["nginx"];
	}
}

define site($root, $port) {
	file { 
		"/etc/nginx/sites-available/${name}": 
			content => template("nginx/proxy_site"), 
			notify => Service["nginx"],
			require => Package["nginx"];
		"/etc/nginx/sites-enabled/${name}": 
			ensure => "/etc/nginx/sites-available/${name}",
			require => File["/etc/nginx/sites-available/${name}"],
			notify => Service["nginx"]; 
	}
}
