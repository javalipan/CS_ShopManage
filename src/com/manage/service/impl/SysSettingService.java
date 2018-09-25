package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.SysSettingMapper;
import com.manage.dao.model.SysSetting;
import com.manage.dao.model.SysSettingExample;
import com.manage.service.ISysSettingService;

@Service
public class SysSettingService implements ISysSettingService {

	@Autowired
	private SysSettingMapper sysSettingMapper;
	
	public int countByExample(SysSettingExample example) {
		return sysSettingMapper.countByExample(example);
	}

	public int deleteByExample(SysSettingExample example) {
		return sysSettingMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return sysSettingMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(SysSetting record) {
		return sysSettingMapper.insertSelective(record);
	}

	public List<SysSetting> selectByExample(SysSettingExample example) {
		return sysSettingMapper.selectByExample(example);
	}

	public SysSetting selectByPrimaryKey(Long id) {
		return sysSettingMapper.selectByPrimaryKey(id);
	}

	public int updateByExampleSelective(SysSetting record,
			SysSettingExample example) {
		return sysSettingMapper.updateByExampleSelective(record, example);
	}

	public int updateByPrimaryKeySelective(SysSetting record) {
		return sysSettingMapper.updateByPrimaryKeySelective(record);
	}

}
