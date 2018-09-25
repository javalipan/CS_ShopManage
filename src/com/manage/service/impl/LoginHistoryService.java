package com.manage.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.LoginHistoryMapper;
import com.manage.dao.model.LoginHistory;
import com.manage.dao.model.LoginHistoryExample;
import com.manage.query.mapper.LoginHistoryQueryMapper;
import com.manage.service.ILoginHistoryService;

@Service
public class LoginHistoryService implements ILoginHistoryService {

	@Autowired
	private LoginHistoryMapper loginHistoryMapper;
	@Autowired
	private LoginHistoryQueryMapper loginHistoryQueryMapper;
	
	public int countByExample(LoginHistoryExample example) {
		return loginHistoryMapper.countByExample(example);
	}

	public List<LoginHistory> selectByExample(LoginHistoryExample example) {
		return loginHistoryMapper.selectByExample(example);
	}

	public LoginHistory selectByPrimaryKey(Long id) {
		return loginHistoryMapper.selectByPrimaryKey(id);
	}

	public List<Map<String, Object>> sumLoginHistory(String startTime,
			String endTime) {
		return loginHistoryQueryMapper.sumLoginHistory(startTime, endTime);
	}

}
