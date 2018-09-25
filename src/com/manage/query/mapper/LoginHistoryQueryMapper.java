package com.manage.query.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface LoginHistoryQueryMapper {

	/**
	 * 统计访问量
	 * @param startTime :开始时间
	 * @param endTime ：结束时间
	 * @return
	 */
	public List<Map<String, Object>> sumLoginHistory(@Param("startTime")String startTime,@Param("endTime")String endTime);
}
