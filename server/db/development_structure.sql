CREATE TABLE `event_properties` (
  `id` int(11) NOT NULL auto_increment,
  `key_algorithm` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `events` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `type` varchar(255) default NULL,
  `ip_address` varchar(255) default NULL,
  `key_algorithm` varchar(255) default NULL,
  `key_hash` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `user_properties` (
  `id` int(11) NOT NULL auto_increment,
  `password_algorithm` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `password_algorithm` varchar(255) NOT NULL default '',
  `password_hash` varchar(255) NOT NULL default '',
  `password_salt` varchar(255) NOT NULL default '',
  `display_name` varchar(255) default NULL,
  `activation_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (5)