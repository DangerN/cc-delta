drop table if exists boards;

create table boards (
	id varchar(6) primary key not null,
	name varchar(40) not null,
	flags varchar[] default '{''}',
	thread_limit smallint default 25
);

insert into boards (id, name, flags)
values
('vg', 'Video Games', '{"sfw"}'),
('ck', 'Food and Cooking', '{"sfw"}'),
('fit', 'Fitness', '{"gay","sfw"}'),
('3', '3D Computer Graphics', '{"sfw"}'),
('tg', 'Traditional Gaming', '{"sfw"}');

select * from boards;
