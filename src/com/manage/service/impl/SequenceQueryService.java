package com.manage.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.query.mapper.SequenceQueryMapper;
import com.manage.service.ISequenceQueryService;

@Service
public class SequenceQueryService implements ISequenceQueryService {

	@Autowired
	private SequenceQueryMapper sequenceQueryMapper;
	
	public Long getSeqNextVal(String sequenceName) {
		return sequenceQueryMapper.getSeqNextVal(sequenceName);
	}

}
