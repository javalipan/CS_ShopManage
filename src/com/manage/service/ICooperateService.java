package com.manage.service;

import java.util.List;

import com.manage.dao.model.Cooperate;
import com.manage.dao.model.CooperateExample;

public interface ICooperateService {

	int countByExample(CooperateExample example);

    int deleteByExample(CooperateExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Cooperate record);

    List<Cooperate> selectByExampleWithBLOBs(CooperateExample example);

    List<Cooperate> selectByExample(CooperateExample example);

    Cooperate selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Cooperate record);

    int updateByPrimaryKeyWithBLOBs(Cooperate record);

    public boolean saveCooperate(Cooperate record,String json);
}
