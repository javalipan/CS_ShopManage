package com.manage.service;

import java.util.List;

import com.manage.dao.model.Msg;
import com.manage.dao.model.MsgExample;

public interface IMsgService {
	
	int countByExample(MsgExample example);

    int deleteByExample(MsgExample example);

    int deleteByPrimaryKey(String id);

    int insertSelective(Msg record);

    List<Msg> selectByExample(MsgExample example);

    Msg selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Msg record);

}
