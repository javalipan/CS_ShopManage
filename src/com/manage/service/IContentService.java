package com.manage.service;

import java.util.List;

import com.manage.dao.model.Content;
import com.manage.dao.model.ContentExample;

public interface IContentService {
	int countByExample(ContentExample example);

    int deleteByExample(ContentExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Content record);

    List<Content> selectByExampleWithBLOBs(ContentExample example);

    List<Content> selectByExample(ContentExample example);

    Content selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Content record);

}
