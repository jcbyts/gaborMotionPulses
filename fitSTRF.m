function [obj, scoreObj] = fitSTRF(data, fitType, llstr, scorestr, ...
    label, foldinds)

    obj.dt = data.dt;
    obj.dt_fit = datestr(now);
    obj.label = label;
    obj.shape = [data.ns data.nt];
    obj.llstr = llstr;
    obj.foldinds = foldinds;
    obj.isLinReg = ~strcmpi(llstr, 'bern');

    scoreObj = reg.getScoreObj(obj.isLinReg, scorestr);

    X = data.X;
    Y = data.Y;
    D = data.D;
    switch fitType
        case 'Flat'
            obj = reg.getObj_Flat(X, Y, obj);
        case 'ML'
            obj = reg.getObj_ML(X, Y, obj);        
    	case 'ASD'
            obj = reg.getObj_ASD(X, Y, D, scoreObj, obj);
    end
    obj = reg.fitAndScore(X, Y, obj, scoreObj);
    obj = tools.rmfieldsRegexp(obj, {'Fcn$', 'FcnArgs$'}, true);

end
