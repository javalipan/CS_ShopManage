package com.manage.service;

import java.util.List;

import com.manage.dao.model.Repertory;
import com.manage.dao.model.RepertoryExample;
import com.manage.query.model.RepertoryQuery;

public interface IRepertoryService {

	int countByExample(RepertoryExample example);
	
	int deleteByExample(RepertoryExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Repertory record);

    List<Repertory> selectByExample(RepertoryExample example);

    Repertory selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Repertory record);
    
    public List<RepertoryQuery> selectByRepertoryQuery(RepertoryQuery repertoryQuery);
	public Integer countByRepertoryQuery(RepertoryQuery repertoryQuery);

	public boolean saveRepertory(String json);
}
