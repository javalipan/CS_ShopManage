package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.StyleMapper;
import com.manage.dao.model.Style;
import com.manage.dao.model.StyleExample;
import com.manage.service.IStyleService;

@Service
public class StyleService implements IStyleService {

	@Autowired
	private StyleMapper styleMapper;
	
	public int countByExample(StyleExample example) {
		return styleMapper.countByExample(example);
	}
	
	public int deleteByExample(StyleExample example) {
		return styleMapper.deleteByExample(example);
	}
	
	public int deleteByPrimaryKey(Long id) {
		return styleMapper.deleteByPrimaryKey(id);
	}
	
	public int insertSelective(Style record) {
		return styleMapper.insertSelective(record);
	}
	
	public List<Style> selectByExample(StyleExample example) {
		return styleMapper.selectByExample(example);
	}
	
	public Style selectByPrimaryKey(Long id) {
		return styleMapper.selectByPrimaryKey(id);
	}
	
	public int updateByPrimaryKeySelective(Style record) {
		return styleMapper.updateByPrimaryKeySelective(record);
	}
	
}
