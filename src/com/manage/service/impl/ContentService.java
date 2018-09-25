package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.ContentMapper;
import com.manage.dao.model.Content;
import com.manage.dao.model.ContentExample;
import com.manage.service.IContentService;

@Service
public class ContentService implements IContentService {

	@Autowired
	private ContentMapper contentMapper;
	
	public int countByExample(ContentExample example) {
		return contentMapper.countByExample(example);
	}

	public int deleteByExample(ContentExample example) {
		return contentMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return contentMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Content record) {
		return contentMapper.insertSelective(record);
	}

	public List<Content> selectByExampleWithBLOBs(ContentExample example) {
		return contentMapper.selectByExampleWithBLOBs(example);
	}

	public List<Content> selectByExample(ContentExample example) {
		return contentMapper.selectByExample(example);
	}

	public Content selectByPrimaryKey(Long id) {
		return contentMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Content record) {
		return contentMapper.updateByPrimaryKeySelective(record);
	}

}
