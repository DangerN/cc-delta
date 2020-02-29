drop table if exists vg_posts;
drop table if exists vg_threads;

create table vg_threads (
	id serial primary key not null,
	flags varchar[] default '{''}',
	post_limit smallint default 350
);

create table vg_posts (
	id bigserial primary key not null,
	badges text default '[]',
	flags text default '[]',
	media_name varchar(50) default '',
	subject varchar(45) default '',
	name varchar(25) default '',
	text text,
	created_at timestamp with time zone default now(),
	thread_id int references vg_threads(id) not null
);

insert into vg_threads (flags)
values('{"active"}');

insert into vg_posts (media_name, subject, name, thread_id, text)
values
('cute-potato', 'butter', 'sneed', 1, 'Good morning'),
('', '', '', 1, 'YOLO');

drop table if exists tg_posts;
drop table if exists tg_threads;

create table tg_threads (
	id serial primary key not null,
	flags varchar[] default '{''}',
	post_limit smallint default 350
);

create table tg_posts (
	id bigserial primary key not null,
	badges text default '[]',
	flags text default '[]',
	media_name varchar(50) default '',
	subject varchar(45) default '',
	name varchar(25) default '',
	text text,
	created_at timestamp with time zone default now(),
	thread_id int references tg_threads(id) not null
);

insert into tg_threads (flags)
values('{"active"}');

insert into tg_posts (media_name, subject, name, thread_id, text)
values
('cute-potato', 'butter', 'sneed', 1, 'Good morning'),
('', '', '', 1, 'YOLO');

drop table if exists fit_posts;
drop table if exists fit_threads;

create table fit_threads (
	id serial primary key not null,
	flags varchar[] default '{''}',
	post_limit smallint default 350
);

create table fit_posts (
	id bigserial primary key not null,
	badges text default '[]',
	flags text default '[]',
	media_name varchar(50) default '',
	subject varchar(45) default '',
	name varchar(25) default '',
	text text,
	created_at timestamp with time zone default now(),
	thread_id int references fit_threads(id) not null
);

insert into fit_threads (flags)
values('{"active"}');

insert into fit_posts (media_name, subject, name, thread_id, text)
values
('cute-potato', 'butter', 'sneed', 1, 'Good morning'),
('', '', '', 1, 'YOLO');

drop table if exists ck_posts;
drop table if exists ck_threads;

create table ck_threads (
	id serial primary key not null,
	flags varchar[] default '{''}',
	post_limit smallint default 350
);

create table ck_posts (
	id bigserial primary key not null,
	badges text default '[]',
	flags text default '[]',
	media_name varchar(50) default '',
	subject varchar(45) default '',
	name varchar(25) default '',
	text text,
	created_at timestamp with time zone default now(),
	thread_id int references ck_threads(id) not null
);

insert into ck_threads (flags)
values('{"active"}');

insert into ck_posts (media_name, subject, name, thread_id, text)
values
('cute-potato', 'butter', 'sneed', 1, 'Good morning'),
('', '', '', 1, 'YOLO');

drop table if exists "3_posts";
drop table if exists "3_threads";

create table "3_threads" (
	id serial primary key not null,
	flags varchar[] default '{''}',
	post_limit smallint default 350
);

create table "3_posts" (
	id bigserial primary key not null,
	badges text default '[]',
	flags text default '[]',
	media_name varchar(50) default '',
	subject varchar(45) default '',
	name varchar(25) default '',
	text text,
	created_at timestamp with time zone default now(),
	thread_id int references "3_threads"(id) not null
);

insert into "3_threads" (flags)
values('{"active"}');

insert into "3_posts" (media_name, subject, name, thread_id, text)
values
('cute-potato', 'butter', 'sneed', 1, 'Good morning'),
('', '', '', 1, 'YOLO');
