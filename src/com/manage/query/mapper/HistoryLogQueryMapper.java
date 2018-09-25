package com.manage.query.mapper;

import java.util.List;

import com.manage.query.model.HistoryLogQuery;

public interface HistoryLogQueryMapper {

	List<HistoryLogQuery> selectByHistoryLogQuery(HistoryLogQuery historyLogQuery);
	
	int countByHistoryLogQuery(HistoryLogQuery historyLogQuery);
}
