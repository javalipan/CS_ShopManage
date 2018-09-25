package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.ProgramMapper;
import com.manage.dao.model.Program;
import com.manage.dao.model.ProgramExample;
import com.manage.service.IProgramService;

@Service
public class ProgramService implements IProgramService {

	@Autowired
	private ProgramMapper programMapper;

	public int countByExample(ProgramExample example) {
		return programMapper.countByExample(example);
	}

	public int deleteByExample(ProgramExample example) {
		return programMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return programMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Program record) {
		return programMapper.insertSelective(record);
	}

	public List<Program> selectByExample(ProgramExample example) {
		return programMapper.selectByExample(example);
	}

	public Program selectByPrimaryKey(Long id) {
		return programMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Program record) {
		return programMapper.updateByPrimaryKeySelective(record);
	}
}
