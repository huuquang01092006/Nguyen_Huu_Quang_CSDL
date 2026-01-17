use social_network_pro;

delimiter $$

create procedure NotifyFriendsOnNewPost (
	in p_user_id int,
	in p_content text
)
begin
	declare done int default 0;
	declare v_friend_id int;
	declare v_name varchar(255);

	declare c cursor for
		select friend_id from friends
		where user_id = p_user_id and status = 'accepted'
		union
		select user_id from friends
		where friend_id = p_user_id and status = 'accepted';

	declare continue handler for not found set done = 1;

	insert into posts (user_id, content)
	values (p_user_id, p_content);

	select full_name into v_name
	from users
	where user_id = p_user_id;

	open c;

	read_loop: loop
		fetch c into v_friend_id;
		if done = 1 then
			leave read_loop;
		end if;

		if v_friend_id != p_user_id then
			insert into notifications (user_id, type, content)
			values (
				v_friend_id,
				'new_post',
				concat(v_name, ' đã đăng một bài viết mới')
			);
		end if;
	end loop;

	close c;

	select 'Đã gửi thông báo' as result;
end $$

delimiter ;

call NotifyFriendsOnNewPost(1, 'Bài viết cuối để nộp');

select *
from notifications
where type = 'new_post'
order by notification_id;

drop procedure NotifyFriendsOnNewPost;
