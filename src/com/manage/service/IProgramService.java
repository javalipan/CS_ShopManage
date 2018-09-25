package com.manage.service;

import java.util.List;

import com.manage.dao.model.Program;
import com.manage.dao.model.ProgramExample;

public interface IProgramService {
	int countByExample(ProgramExample example);

    int deleteByExample(ProgramExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Program record);

    List<Program> selectByExample(ProgramExample example);

    Program selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Program record);

}
