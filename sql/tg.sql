drop table if exists tg_posts;
drop table if exists tg_threads;

create table tg_threads (
	id serial primary key not null,
	flags text,
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
values('[active]');

insert into tg_posts (media_name, subject, name, thread_id, text)
values
('cute-potato', 'butter', 'sneed', 1, 'Good morning'),
('', '', '', 1, 'YOLO');
