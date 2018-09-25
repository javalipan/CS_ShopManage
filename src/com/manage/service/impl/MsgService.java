package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.MsgMapper;
import com.manage.dao.model.Msg;
import com.manage.dao.model.MsgExample;
import com.manage.service.IMsgService;

@Service
public class MsgService implements IMsgService {

	@Autowired
	private MsgMapper msgMapper;
	
	public int countByExample(MsgExample example) {
		return msgMapper.countByExample(example);
	}

	public int deleteByExample(MsgExample example) {
		return msgMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(String id) {
		return msgMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Msg record) {
		return msgMapper.insertSelective(record);
	}

	public List<Msg> selectByExample(MsgExample example) {
		return msgMapper.selectByExample(example);
	}

	public Msg selectByPrimaryKey(String id) {
		return msgMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Msg record) {
		return msgMapper.updateByPrimaryKeySelective(record);
	}

}
