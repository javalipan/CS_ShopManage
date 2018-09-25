package com.manage.service;

import java.util.List;

import com.manage.dao.model.GoodsBrowseHis;
import com.manage.dao.model.GoodsBrowseHisExample;
import com.manage.query.model.GoodsBrowseHisQuery;

public interface IGoodsBrowseHisService {
	int countByExample(GoodsBrowseHisExample example);

    int deleteByExample(GoodsBrowseHisExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(GoodsBrowseHis record);

    List<GoodsBrowseHis> selectByExample(GoodsBrowseHisExample example);

    GoodsBrowseHis selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(GoodsBrowseHis record);

    public List<GoodsBrowseHisQuery> sumBrowseHistory(GoodsBrowseHisQuery goodsBrowseHisQuery);
    
    /** 
	*  根据条件查询列表
	* @param goodsBrowseHisQuery
	* @return List<GoodsBrowseHisQuery>     
	*/
	public List<GoodsBrowseHisQuery> selectByGoodsBrowseHisQuery(GoodsBrowseHisQuery goodsBrowseHisQuery);
	/** 
	*  查询条数
	* @param goodsBrowseHisQuery
	* @return Integer     
	*/
	public Integer countByGoodsBrowseHisQuery(GoodsBrowseHisQuery goodsBrowseHisQuery);
}
