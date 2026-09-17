-- 第五十九轮补充：2D 签到墙头像尺寸对齐原版 meepo（AvatarSize=5）
update gs_threedimensional
set avatar_size = 5, avatar_gap = 5
where avatar_size is null or avatar_size >= 40;
