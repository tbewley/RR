classdef TenSimStateClass
   properties                % state vector for a tensegrity system:
      Ra    {mustBeNumeric}; % Ra(1:3,1:a)=locations of center of mass of each solid body
      Radot {mustBeNumeric}; % time derivative of Ra
      Da    {mustBeNumeric}; % Da(1:4,1:a)=unit quaternions giving orientation of each solid body
      Oa    {mustBeNumeric}; % Oa(1:3,1:a)=rate of rotaion of each solid body
      Rb    {mustBeNumeric}; % Rb(1:3,1:b)=locations of center of mass of each bar
      Rbdot {mustBeNumeric}; % time derivative of Rb
      Db    {mustBeNumeric}; % Db(1:3,1:b)=normalized direction vectors giving orientation of each bar
      Hb    {mustBeNumeric}; % Hb(1:3,1:b)=angular momentum of each bar
      Rc    {mustBeNumeric}; % Rc(1:3,1:a)=locations of each isolated nodal point
      Rcdot {mustBeNumeric}; % time derivative of Rc
   end
   methods
      function x = plus(x1,x2)
         x=TenSimStateClass;
         x.Ra   =[x1.Ra   ]+[x2.Ra   ];
         x.Radot=[x1.Radot]+[x2.Radot];
         x.Da   =[x1.Da   ]+[x2.Da   ];
         x.Oa   =[x1.Oa   ]+[x2.Oa   ];
         x.Rb   =[x1.Rb   ]+[x2.Rb   ];
         x.Rbdot=[x1.Rbdot]+[x2.Rbdot];
         x.Db   =[x1.Db   ]+[x2.Db   ];
         x.Hb   =[x1.Hb   ]+[x2.Hb   ];
         x.Rc   =[x1.Rc   ]+[x2.Rc   ];
         x.Rcdot=[x1.Rcdot]+[x2.Rcdot];
      end       
      function x = mtimes(x1,c)
         x=TenSimStateClass;
         x.Ra   =[x1.Ra   ]*c;
         x.Radot=[x1.Radot]*c;
         x.Da   =[x1.Da   ]*c;
         x.Oa   =[x1.Oa   ]*c;
         x.Rb   =[x1.Rb   ]*c;
         x.Rbdot=[x1.Rbdot]*c;
         x.Db   =[x1.Db   ]*c;
         x.Hb   =[x1.Hb   ]*c;
         x.Rc   =[x1.Rc   ]*c;
         x.Rcdot=[x1.Rcdot]*c;
      end
      function x = mrdivide(x1,c)
         x=TenSimStateClass;
         x.Ra   =[x1.Ra   ]/c;
         x.Radot=[x1.Radot]/c;
         x.Da   =[x1.Da   ]/c;
         x.Oa   =[x1.Oa   ]/c;
         x.Rb   =[x1.Rb   ]/c;
         x.Rbdot=[x1.Rbdot]/c;
         x.Db   =[x1.Db   ]/c;
         x.Hb   =[x1.Hb   ]/c;
         x.Rc   =[x1.Rc   ]/c;
         x.Rcdot=[x1.Rcdot]/c;
      end
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
